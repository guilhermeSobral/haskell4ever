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
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(luciusFile "templates/principal/home.lucius")
        toWidgetHead $(juliusFile "templates/principal/home.julius")

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
            
            <img src=@{StaticR mimikyu_jpg}>   
            
            <button class="btn btn-danger" onclick="ola()">
               OI!
        |]          
    