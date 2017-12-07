import { Component         } from "@angular/core";
import { HttpClient        } from '@angular/common/http';
import { Ng4LoadingSpinnerService } from 'ng4-loading-spinner';
import template              from "./template.html";
import * as d3 from "d3";
import * as $ from "jquery";

var DashboardViewComponent = Component({
    selector: "dashboard-view",
    template: template
}).Class({
    constructor: [
        HttpClient,
        Ng4LoadingSpinnerService,
        function(http, spinnerService) {
            this.http = http;
            this.spinnerService = spinnerService;
        }
    ],
    // Gets all the calculations for the user when dashboard is visited
    ngOnInit() {
        var selects = $('.currency-drop-down');
        selects.change(function() {
            // build array of selected option indexes
            var indexes = [];
            $.each(selects, function() {
                indexes.push($(this).children('option:selected').index());
            });
            $.each(selects, function() {
                var selected = $(this).children('option:selected').index();
                $.each($(this).children('option'), function(index, item) {
                    if ($(this).val() && indexes.indexOf(index) > -1 && index != selected) {
                        $(this).prop('disabled', true);
                    } else {
                        $(this).prop('disabled', false);
                    }
                });
            });
        });
        var self = this;
        self.http.get(
            "/dashboard.json"
        ).subscribe(
            data => { self.calculations = data['calculations'] }
        );
    },
    // Submits the form to make a calculation
    onSubmit(form: any) {
        var self = this;
        self.spinnerService.show();
        self.http.post(
            "/dashboard", form
        ).subscribe(
            data => {
                if (data.error.calculation_name !== undefined) {
                    alert(`The calculation name ${data.name} has already been taken.`);
                }
                self.spinnerService.hide();
                self.ngOnInit()
            }
        );
    },
    // Renders the table and graph for a the selected calculation
    viewCalculation: function(calculation) {
        var self = this;
        var id = calculation.id
        self.id = id;
        self.http.get(
            "/dashboard.json?id=" + self.id
        ).subscribe(
            data => {
                self.saved_weekly_calculations = data['saved_weekly_calculations']
                d3.select("svg").remove();

                // Set the margins, width and height
                var margin = {top: 10, right: 20, bottom: 80, left: 60},
                    width = 550 - margin.left - margin.right,
                    height = 380 - margin.top - margin.bottom;

                // Set the x and y scales
                var x = d3.scaleBand()
                    .range([0, width])
                    .padding(0.1);
                var y = d3.scaleLinear()
                    .range([height, 0])

                // Create the SVG
                var svg = d3.select("#chart").append("svg")
                    .attr("width", width + margin.left + margin.right)
                    .attr("height", height + margin.top + margin.bottom)
                    .append("g")
                    .attr("transform",
                        "translate(" + margin.left + "," + margin.top + ")");

                // format the data
                data['saved_weekly_calculations'].forEach(function(d) {
                    d.sum = +d.sum;
                });

                // Scale the range of the data in the domains
                x.domain(data['saved_weekly_calculations'].map(function(d) { return d.year_and_week; }));
                var y_domain_min = d3.min(data['saved_weekly_calculations'], function(d) { return d.sum; })
                y.domain([y_domain_min-(y_domain_min*.02), d3.max(data['saved_weekly_calculations'], function(d) { return d.sum; })]);

                // append the rectangles for the bar chart
                svg.selectAll(".bar")
                    .data(data['saved_weekly_calculations'])
                    .enter().append("rect")
                    .attr("class", "bar")
                    .attr("x", function(d) { return x(d.year_and_week); })
                    .attr("width", x.bandwidth())
                    .attr("y", function(d) { return y(d.sum); })
                    .attr("height", function(d) { return height - y(d.sum); });

                // add the x Axis
                svg.append("g")
                    .attr("transform", "translate(0," + height + ")")
                    .call(d3.axisBottom(x));

                // text label for the x axis
                svg.append("text")
                    .attr("transform",
                        "translate(" + (width/2) + " ," +
                        (height + margin.top + 35) + ")")
                    .style("text-anchor", "middle")
                    .text("Date");

                // add the y Axis
                svg.append("g")
                    .call(d3.axisLeft(y));

                // text label for the y axis
                svg.append("text")
                    .attr("transform", "rotate(-90)")
                    .attr("y", 0 - margin.left)
                    .attr("x",0 - (height / 2))
                    .attr("dy", "1em")
                    .style("text-anchor", "middle")
                    .text("Sum");
            }
        );
    },
    // Deletes the calculation name and associated weekly calculations on click
    deleteCalculation: function(calculation) {
        var self = this;
        var id = calculation.id;
        self.id = id;
        self.http.delete(
            "/dashboard/" + self.id
        ).subscribe(
            data => {
                self.ngOnInit();
                self.http.get(
                    "/dashboard.json?id=" + self.id
                ).subscribe(
                    data => {
                        self.saved_weekly_calculations = data['saved_weekly_calculations']
                        d3.select("svg").remove();
                    }
                );

            }
        );
    }
});

export { DashboardViewComponent };