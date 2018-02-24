//
//  SampleData.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 2/23/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation

let AUTHENTICATE_SAMPLE: String = "{\"code\": 200,\"status\": \"success\",\"data\": {\"auth\": true,\"token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lIiwiaWF0IjoxNTE5NDQzMzUxLCJleHAiOjE1MTk1Mjk3NTF9.PVoHanWIY7k0xUvy6xJzNOZMjem8XaSyUO7RtDeIt4k\",\"id\": 1},\"message\": \"Authenticated user.\"}"

let REGISTER_SAMPLE: String = "{\"code\": 201,\"status\": \"success\",\"data\": {\"auth\": true,\"token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXJuYW1lNSIsImlhdCI6MTUxOTQ0MzU3NiwiZXhwIjoxNTE5NTI5OTc2fQ.Vnk2o-MQssmfkdSg8ivpCXZFn8wO1M8e7UgIOZz-5bY\",\"id\": 9},\"message\": \"Created a new user.\"}"

let GET_ALL_TRUCKS_SAMPLE: String = "{\"code\": 200,\"status\": \"success\",\"data\": [{\"truck_id\": 1,\"twitter_handle\": \"@spitztruckla\",\"url\": \"https://pbs.twimg.com/media/DWqIDC7XcAEFGjt.jpg:large\",\"name\": \"SpitzTruck LA\",\"phone\": \"\",\"address\": \"Wilshire Blvd & Midvale Ave, Los Angeles, CA 90024\",\"date_open\": \"2018-02-22T08:00:00.000Z\",\"time_open\": \"11:30:00\",\"time_range\": 180,\"broadcasting\": false}],\"message\": \"Retrieved all trucks.\"}"

let GET_TRUCK_SAMPLE: String = "{\"code\": 200,\"status\": \"success\",\"data\": {\"truck_id\": 1,\"twitter_handle\": \"@spitztruckla\",\"url\": \"https://pbs.twimg.com/media/DWqIDC7XcAEFGjt.jpg:large\",\"name\": \"SpitzTruck LA\",\"phone\": \"\",\"address\": \"Wilshire Blvd & Midvale Ave, Los Angeles, CA 90024\",\"date_open\": \"2018-02-22T08:00:00.000Z\",\"time_open\": \"11:30:00\",\"time_range\": 180,\"broadcasting\": false},\"message\": \"Retrieved truck 1.\"}"

let GET_ALL_USERS_SAMPLE: String = "{\"code\": 200,\"status\": \"success\",\"data\": [{\"user_id\": 1,\"username\": \"username\",\"hashed_password\": \"$2a$10$RdnCpUNkxJscNHt.JVHszO8OMkSIdkE0PY1MQhx5DacoMxE2Zmkam\",\"first_name\": \"Kevin\",\"last_name\": \"Nguyen\",\"email\": \"knagoogin@gmail.com\"}],\"message\": \"Retrieved all users.\"}"

let GET_USER_SAMPLE: String = "{\"code\": 200,\"status\": \"success\",\"data\": {\"user_id\": 1,\"username\": \"username\",\"hashed_password\": \"$2a$10$RdnCpUNkxJscNHt.JVHszO8OMkSIdkE0PY1MQhx5DacoMxE2Zmkam\",\"first_name\": \"Kevin\",\"last_name\": \"Nguyen\",\"email\": \"knagoogin@gmail.com\"},\"message\": \"Retrieved user 1.\"}"

let DELETE_USER_SAMPLE: String = "{\"code\": 200,\"status\": \"success\",\"message\": \"Removed 1 user.\"}"
