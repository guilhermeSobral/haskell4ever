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

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead [julius|
            function ola(){
                alert("oi");
            }
        |]
        toWidgetHead [cassius|
            h1
               color : blue;
        |]
        [whamlet|
            <h1>
               OI MUNDO!
            <h1>
                Upei algo no server!
            
            <img src=@{StaticR mimikyu_jpg}>   
            
            <button class="btn btn-danger" onclick="ola()">
               OI!
        |]          
    