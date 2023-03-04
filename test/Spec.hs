{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson (decode, Value)
import AnalyseDamage.ApiResponse (ApiOutput)

main :: IO ()
main =
  let a :: Maybe ApiOutput
      a = decode "{\"draw_result\":false,\"job_id\":\"f18612ce-93dd-445a-8048-10f0f8a4efc6\",\"output\":{\"elements\":[{\"bbox\":[202,697,288,756],\"damage_category\":\"slight_scratch\",\"damage_color\":[50,50,100],\"damage_id\":\"1\",\"damage_location\":\"front_bumper\",\"score\":0.640678},{\"bbox\":[204,417,485,545],\"damage_category\":\"slight_scratch\",\"damage_color\":[50,50,100],\"damage_id\":\"1\",\"damage_location\":\"front_bumper\",\"score\":0.440228},{\"bbox\":[318,525,475,593],\"damage_category\":\"slight_scratch\",\"damage_color\":[50,50,100],\"damage_id\":\"1\",\"damage_location\":\"front_bumper\",\"score\":0.336784},{\"bbox\":[429,268,691,406],\"damage_category\":\"medium_deformation\",\"damage_color\":[0,115,255],\"damage_id\":\"4\",\"damage_location\":\"left_front_wing\",\"score\":0.751663},{\"bbox\":[415,339,542,506],\"damage_category\":\"fender/bumper_damage\",\"damage_color\":[70,50,0],\"damage_id\":\"8\",\"damage_location\":\"front_bumper\",\"score\":0.854546},{\"bbox\":[393,301,645,518],\"damage_category\":\"fender/bumper_damage\",\"damage_color\":[70,50,0],\"damage_id\":\"8\",\"damage_location\":\"left_front_wing\",\"score\":0.385057}]}}\n"
  in print a