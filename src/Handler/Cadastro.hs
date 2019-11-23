{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Cadastro where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

getPostagemR :: Handler Html
getPostagemR = do
    defaultLayout $ do
        $(whamletFile "templates/cadastro/cadastro.hamlet")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/cadastro/cadastro.lucius")
        toWidgetHead $(juliusFile "templates/cadastro/cadastro.julius")
        
postPostagemR :: Handler ()
postPostagemR = do
    postagem <- runInputPost $ Postagem
       <$> ireq textField "titulo"
       <*> ireq textareaField "conteudo"
    runDB $ insert postagem  
    redirect HomeR
    