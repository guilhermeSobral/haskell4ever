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
        addScriptRemote "https://code.jquery.com/jquery-3.4.1.min.js"
        
postPostagemR :: Handler Html
postPostagemR = do
    postagem <- runInputPost $ Postagem
       <$> ireq textField "titulo"
       <*> ireq textareaField "conteudo"
    runDB $ insert postagem  
    redirect HomeR
    
getPostagemIdR :: PostagemId -> Handler Value
getPostagemIdR produtoId = do
    postagem <- runDB $ get404 produtoId
    sendStatusJSON ok200 postagem
    