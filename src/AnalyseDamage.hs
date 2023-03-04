{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module AnalyseDamage where

import Data.ByteString (ByteString)
import Network.HTTP.Simple (Request, parseRequest, Header, setRequestHeaders, setRequestBodyJSON, setRequestSecure, httpLBS)
import Data.Maybe (fromJust)
import Data.Text (Text)
import Data.Aeson (ToJSON (toEncoding), genericToEncoding, defaultOptions, eitherDecode)
import GHC.Generics (Generic)
import Data.ByteString.Base64 (encodeBase64)
import Network.HTTP.Client.Conduit (responseBody)
import AnalyseDamage.ApiResponse (ApiOutput, displayApiOutput)
import ParseCsv (getPartCosts, getMultipliers)
import qualified Data.Map.Strict as M
import Control.Applicative (liftA2)

type Image = ByteString
type ApiKey = ByteString

-- | Given a list of images, output a list of damaged car parts according
-- to the image classification model.
-- Format: "car_part damage_category cost"
-- Also outputs "Total cost: [SUM]"
analyseImages :: ApiKey -> [Image] -> IO [String]
analyseImages apiKey imgs = do
  rawOutputs <- mapM (runModel apiKey) imgs
  let damages = concatMap displayApiOutput rawOutputs
  partMap <- getPartCosts
  multiplierMap <- getMultipliers
  let costs = map (\(part,category) ->
        fromJust $
        liftA2 (*)
        (fmap realToFrac (M.lookup part partMap))
        (M.lookup category multiplierMap)) damages
  let damageReports = zipWith (\(path,category) cost ->
        path
        ++ " " ++
        category
        ++ " " ++
        show cost)
        damages costs
  pure (damageReports ++ ["Total cost: " ++ show (sum costs)])

runModel :: ApiKey -> Image -> IO ApiOutput
runModel apiKey image = do
  response <- httpLBS (apiRequest apiKey image)
  let mapiOutput = eitherDecode (responseBody response)
  case mapiOutput of
    Right apiOutput -> pure apiOutput
    Left e -> fail ("Failed to parse returned JSON: " ++ show e)

-- | Given an Image and the api key, construct an HTTP request to server
-- hosting the AI model.
apiRequest :: ApiKey -> Image -> Request
apiRequest apiKey image =
  setRequestSecure True
  . setRequestBodyJSON body
  . setRequestHeaders headers
  $ baseRequest
  where
    baseRequest = fromJust $ parseRequest "POST https://vehicle-damage-assessment.p.rapidapi.com/run"
    headers =
      [ ("content-type", "application/json")
      , ("X-RapidAPI-Key", apiKey)
      , ("X-RapidAPI-Host", "vehicle-damage-assessment.p.rapidapi.com")] :: [Header]
    body = ApiPayload
      { draw_result = False
      , remove_background = False
      , image = encodeBase64 image
      }

data ApiPayload = ApiPayload
  { draw_result :: Bool
  , remove_background :: Bool
  , image :: Text -- Base64-encoded
  } deriving (Generic, Show)

instance ToJSON ApiPayload where
  toEncoding = genericToEncoding defaultOptions
