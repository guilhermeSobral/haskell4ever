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

getPrincipalR :: Handler Html
getPrincipalR = do
    defaultLayout $ do
        $(whamletFile "templates/principal/home.hamlet")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/principal/home.lucius")
        toWidgetHead $(juliusFile "templates/principal/home.julius")
        
getCadastroR :: Handler Html
getCadastroR = do
    defaultLayout $ do
        $(whamletFile "templates/cadastro/cadastro.hamlet")
         addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/cadastro/cadastro.lucius")
        toWidgetHead $(juliusFile "templates/cadastro/cadastro.julius")
        
getEntrarR :: Handler Html
getEntrarR = do
    defaultLayout $ do
        $(whamletFile "templates/login/login.hamlet")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        toWidgetHead $(luciusFile "templates/login/login.lucius")
        toWidgetHead $(juliusFile "templates/login/login.julius") 

getPage1R :: Handler Html
getPage1R = do
    defaultLayout $ do
        $(whamletFile "templates/page1.hamlet")
        toWidgetHead $(luciusFile "templates/page1.lucius")
        toWidgetHead $(juliusFile "templates/page1.julius")
        
getPage2R :: Handler Html
getPage2R = do  
    defaultLayout $ do
        $(whamletFile "templates/page2.hamlet")

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        sess <- lookupSession "_NOME"
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead [julius|
            function ola(){
                alert("ola!");
            }
        |]
        
        toWidgetHead [cassius|
            h1
               color : blue;
        |]
        
        [whamlet|
            <h1>
               OI MUNDO!
            
            <ul>
                <li>
                    <a href=@{Page1R}>
                        Pagina 1
                <li>
                    <a href=@{Page2R}>
                        Pagina 2
            
            $maybe nomeSess <- sess
                <li>
                    <form method=post action=@{LogoutR}>
                        <input type="submit" value="Sair">
                <div>
                    Ola #{nomeSess}
            $nothing            
                <img src=@{StaticR mimikyu_jpg}>   
            
            <button class="btn btn-danger" onclick="ola()">
               OI!
        |]          
    