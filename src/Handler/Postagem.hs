{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Postagem where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

data Postagem = Postagem {
    titulo :: Text,
    conteudo :: Text
}

getPostagemR :: Handler Html
getPostagemR = do
    defaultLayout $ do
        $(whamletFile "templates/cadastro/cadastro.hamlet")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/cadastro/cadastro.lucius")
        toWidgetHead $(juliusFile "templates/cadastro/cadastro.julius")
    
postPostagemR :: Handler Html
postPostagemR = do
    postagem <- runInputPost $ Postagem
        <$> ireq emailField "titulo"
        <*> ireq passwordField "conteudo"
    postagem -> do
        runDB $ insert postagem
        setMessage [shamlet|
                <h2>
                    PRODUTO INSERIDO COM SUCESSO !
            |]
            redirect ProdutoR
        