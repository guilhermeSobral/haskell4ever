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

formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ ( , )
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing
    
getEntrarR :: Handler Html
getEntrarR = do
    defaultLayout $ do
        $(whamletFile "templates/login/login.hamlet")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/login/login.lucius")
        toWidgetHead $(juliusFile "templates/login/login.julius")
        
postEntrarR :: Handler Html
postEntrarR = do 
    ((result,_),_) <- runFormPost
    case result of
        FormSuccess ("root@root.com", "root") -> do
            setSession "_NOME" "Root"
            redirect AdminR
        FormSuccess (email,senha) -> do
            usuario <- runDB $ getBy (UniqueEmailAdm email)
            case usuario of
                Nothing -> do
                    setMessage [shamlet|
                        <div>
                            E-mail nao encontrado!
                    |]
                    redirect LoginR
                Just (Entity _ usr) -> do
                    if (usuarioSenha usr == senha) then do
                        setSession "_NOME" (usuarioNome usr)
                        redirect HomeR
                    else do
                        setMessage [shamlet|
                            <div>
                                Senha invalida!
                    |]
                    redirect LoginR
        _ -> redirect HomeR        