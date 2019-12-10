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
        
postLoginR :: Handler Html
postLoginR = do 
    ((result,_),_) <- runFormPost formLogin
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
        
postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_NOME"
    redirect HomeR
    
getAdminR :: Handler Html
getAdminR = do 
    defaultLayout [whamlet|
        <h1>
            BEM-VINDO MEU REI!
            
        <a href=@{HomeR}>
            Pagina Inicial
            
        <a href=@{PostagemR}>
            Cadastro de Postagem    
    |]