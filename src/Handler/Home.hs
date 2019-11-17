{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

data Produto = Produto {
    nome :: Text,
    valor :: Double
}

instance ToJSON Coord where
  toJSON (Produto x y) = object ["x" .= x, "y" .= y]


getHomeR :: Handler Html
getHomeR = do
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    defaultLayout $ do
        $(whamletFile "templates/principal/home.hamlet")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/principal/home.lucius")
        addScriptRemote "https://code.jquery.com/jquery-3.3.1.slim.min.js"
        toWidgetBody $(juliusFile "templates/principal/home.julius")