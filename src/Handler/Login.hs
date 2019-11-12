{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ ( , )
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing
    
getLoginR :: Handler Html
getLoginR = do
    (widget, enctype) <- generateFormPost formLogin
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
                    
            <h1>
                LOGIN DE USUARIO !
            <form method=post action=@{LoginR}>
                ^{widget}
                <input type="submit" value="Cadastrar!">
        |]    
        
postUsuarioR :: Handler Html
postUsuarioR = do 
    ((result,_),_) <- runFormPost formUsu
    case result of
        FormSuccess usuario -> do
            runDB $ insert usuario
            setMessage [shamlet|
                <h2>
                    USUARIO INSERIDO COM SUCESSO !
            |]
            redirect UsuarioR
        _ -> redirect HomeR         