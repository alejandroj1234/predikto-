import "polyfills";
import { Component, NgModule              } from "@angular/core";
import { BrowserModule                    } from "@angular/platform-browser";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { platformBrowserDynamic           } from "@angular/platform-browser-dynamic";
import { HttpClientModule                 } from '@angular/common/http';
import { Ng4LoadingSpinnerModule } from 'ng4-loading-spinner';


import { DashboardViewComponent           } from "DashboardViewComponent";

var DashboardAppModule = NgModule({
    imports:    [
        BrowserModule,
        FormsModule,
        ReactiveFormsModule,
        HttpClientModule,
        Ng4LoadingSpinnerModule.forRoot()
    ],
    declarations:   [
        DashboardViewComponent
    ],
    bootstrap: [
        DashboardViewComponent
    ]
}).Class({
    constructor: function() {}
});

platformBrowserDynamic().bootstrapModule(DashboardAppModule);

