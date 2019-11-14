{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Entrar where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

data Login = Login {
    email :: Text,
    password :: Text
} deriving Show
    
getEntrarR :: Handler Html
getEntrarR = do
    defaultLayout $ do
        $(whamletFile "templates/login/login.hamlet")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/login/login.lucius")
        toWidgetHead $(juliusFile "templates/login/login.julius")
        
postEntrarR :: Handler Html
postEntrarR = do 
    result <- runInputPost $ Login
        <$> ireq emailField "email"
        <*> ireq passwordField "senha"
    case result of
        FormSuccess ("root@root.com", "root") -> do
            setSession "_NOME" "Root"
            redirect AdminR
        _ -> redirect HomeR        