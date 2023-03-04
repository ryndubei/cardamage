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

type Image = ByteString
type ApiKey = ByteString

-- | Given a list of images, output a list of damaged car parts according
-- to the image classification model.
analyseImages :: ApiKey -> [Image] -> IO [String]
analyseImages apiKey imgs = do
  rawOutputs <- mapM (runModel apiKey) imgs
  pure (map (show . displayApiOutput) rawOutputs)

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
