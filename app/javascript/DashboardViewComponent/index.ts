import { Component         } from "@angular/core";
import { HttpClient        } from '@angular/common/http';
import template              from "./template.html";

var DashboardViewComponent = Component({
    selector: "dashboard-view",
    template: template
}).Class({
    constructor: [
        HttpClient,
        function(http) {
            this.http = http;
        }
    ],
});

export { DashboardViewComponent };