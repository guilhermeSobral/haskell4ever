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

data BlogPost = BlogPost {
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
    result <- runInputPost $ BlogPost
        <$> ireq emailField "titulo"
        <*> ireq passwordField "conteudo"
    case result of
        (BlogPost x y) -> do
            runDB $ insert (BlogPost)
            setMessage [shamlet|
                <h2>
                    POSTAGEM INSERIDO COM SUCESSO !
            |]
            redirect HomeR
        _ -> redirect PostagemR
        