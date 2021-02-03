// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/config;
import ballerina/system;
import ballerina/log;

ClientEndpointConfiguration config = {
    sasKeyName: getConfigValue("SAS_KEY_NAME"),
    sasKey: getConfigValue("SAS_KEY"),
    resourceUri: getConfigValue("RESOURCE_URI")
};
ManagementClient managementClient = new (config);
PublisherClient publisherClient = new (config);

# Before Suite Function
@test:BeforeSuite
function beforeSuiteFunc() {
    var result = managementClient->createEventHub("myeventhub");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["eventhub"],
    enable: true
}
function testSendEvent() {
    var result = publisherClient->send("myeventhub", "eventData");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventhub"],
    enable: true
}
function testSendEventWithBrokerAndUserProperties() {
    map<string> brokerProps = {"CorrelationId": "32119834", "CorrelationId2": "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    var result = publisherClient->send("myeventhub", "eventData", userProps, brokerProps);
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventhub"],
    enable: true
}
function testSendEventWithPartitionKey() {
    map<string> brokerProps = {PartitionKey: "groupName1", CorrelationId: "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    var result = publisherClient->send("myeventhub", "data", userProps, brokerProps, partitionKey = "groupName");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventhub"],
    enable: true
}
function testSendEventToPartition() {
    map<string> brokerProps = {CorrelationId: "32119834", CorrelationId2: "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    var result = publisherClient->send("myeventhub", "data", userProps, brokerProps, partitionId = 1);
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventhub"],
    enable: true
}
function testSendBatchEvent() {
    map<string> brokerProps = {CorrelationId: "32119834", CorrelationId2: "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    BatchEvent batchEvent = {
        events: [
            {data: "Message1"},
            {data: "Message2", brokerProperties: brokerProps},
            {data: "Message3", brokerProperties: brokerProps, userProperties: userProps}
        ]
    };
    var result = publisherClient->sendBatch("myeventhub", batchEvent);
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventhub"],
    enable: true
}
function testSendBatchEventWithPartitionKey() {
    map<string> brokerProps = {PartitionKey: "groupName", CorrelationId: "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    BatchEvent batchEvent = {
        events: [
            {data: "Message1"},
            {data: "Message2", brokerProperties: brokerProps},
            {data: "Message3", brokerProperties: brokerProps, userProperties: userProps}
        ]
    };
    var result = publisherClient->sendBatch("myeventhub", batchEvent, partitionKey = "groupName");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventhub"],
    enable: true
}
function testSendBatchEventToPartition() {
    map<string> brokerProps = {CorrelationId: "32119834", CorrelationId2: "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    BatchEvent batchEvent = {
        events: [
            {data: "Message1"},
            {data: "Message2", brokerProperties: brokerProps},
            {data: "Message3", brokerProperties: brokerProps, userProperties: userProps}
        ]
    };
    var result = publisherClient->sendBatch("myeventhub", batchEvent, partitionId = 1);
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["publisher"],
    enable: true
}
function testSendBatchEventWithPublisherID() {
    map<string> brokerProps = {CorrelationId: "32119834", CorrelationId2: "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    BatchEvent batchEvent = {
        events: [
            {data: "Message1"},
            {data: "Message2", brokerProperties: brokerProps},
            {data: "Message3", brokerProperties: brokerProps, userProperties: userProps}
        ]
    };
    var result = publisherClient->sendBatch("myeventhub", batchEvent, publisherId = "device-1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventHubManagment"],
    enable: true
}
function testCreateEventHub() {
    var result = managementClient->createEventHub("myhub");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["eventHubManagment"],
    dependsOn: ["testCreateEventHub"],
    enable: true
}
function testGetEventHub() {
    var result = managementClient->getEventHub("myhub");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["eventHubManagment"],
    dependsOn: ["testCreateEventHub"],
    enable: true
}
function testUpdateEventHub() {
    EventHubDescriptionToUpdate eventHubDescriptionToUpdate = {
        MessageRetentionInDays: 5
    };
    var result = managementClient->updateEventHub("myhub", eventHubDescriptionToUpdate);
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

//TODO: Fix xml returned cannot be converted to string
@test:Config {
    groups: ["eventHubManagment"],
    dependsOn: ["testCreateEventHub"],
    enable: true
}
function testListEventHubs() {
    var result = managementClient->listEventHubs();
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print("listReceived");
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["eventHubManagment"],
    dependsOn: [
        "testCreateEventHub",
        "testGetEventHub",
        "testUpdateEventHub",
        "testListEventHubs"
    ],
    enable: true
}
function testDeleteEventHub() {
    var result = managementClient->deleteEventHub("myhub");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["eventHubManagment"],
    dependsOn: ["testDeleteEventHub"],
    enable: true
}
function testCreateEventHubWithEventHubDescription() {
    EventHubDescription eventHubDescription = {
        MessageRetentionInDays: 3,
        PartitionCount: 8
    };
    var result = managementClient->createEventHub("myhubnew", eventHubDescription);
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["eventHubManagment"],
    dependsOn: ["testCreateEventHubWithEventHubDescription"],
    enable: true
}
function testDeleteEventHubWithEventHubDescription() {
    var result = managementClient->deleteEventHub("myhubnew");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["publisher"],
    dependsOn: ["testSendBatchEventWithPublisherID"],
    enable: true
}
function testRevokePublisher() {
    var result = publisherClient->revokePublisher("myeventhub", "device-1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    enable: false
}
function testSendEventWithPublisherID() {
    map<string> brokerProps = {CorrelationId: "32119834", CorrelationId2: "32119834"};
    map<string> userProps = {Alert: "windy", warning: "true"};

    var result = publisherClient->send("myeventhub", "data", userProps, brokerProps, publisherId = "device-1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

//TODO: xml returned cannot be converted to string
@test:Config {
    groups: ["publisher"],
    dependsOn: ["testRevokePublisher"],
    enable: true
}
function testGetRevokedPublishers() {
    var result = publisherClient->getRevokedPublishers("myeventhub");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print("listReceived");
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["publisher"],
    dependsOn: [
        "testRevokePublisher",
        "testGetRevokedPublishers"
    ],
    enable: true
}
function testResumePublisher() {
    var result = publisherClient->resumePublisher("myeventhub", "device-1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
    if (result is ()) {
        log:print("successful");
    }
}

@test:Config {
    groups: ["consumergroup"],
    enable: true
}
function testCreateConsumerGroup() {
    var result = managementClient->createConsumerGroup("myeventhub", "consumerGroup1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["consumergroup"],
    dependsOn: ["testCreateConsumerGroup"],
    enable: true
}
function testGetConsumerGroup() {
    var result = managementClient->getConsumerGroup("myeventhub", "consumerGroup1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["consumergroup"],
    dependsOn: ["testCreateConsumerGroup"],
    enable: true
}
function testListConsumerGroups() {
    var result = managementClient->listConsumerGroups("myeventhub");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print("successful");
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["consumergroup"],
    dependsOn: ["testCreateConsumerGroup"],
    enable: true
}
function testListPartitions() {
    var result = managementClient->listPartitions("myeventhub", "consumerGroup1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print("successful");
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["consumergroup"],
    dependsOn: ["testCreateConsumerGroup"],
    enable: true
}
function testGetPartition() {
    var result = managementClient->getPartition("myeventhub", "consumerGroup1", 1);
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is xml);
    if (result is xml) {
        log:print(result.toString());
    }
}

@test:Config {
    groups: ["consumergroup"],
    dependsOn: [
        "testCreateConsumerGroup",
        "testGetConsumerGroup",
        "testListConsumerGroups",
        "testListPartitions",
        "testGetPartition"
    ],
    enable: true
}
function testDeleteConsumerGroups() {
    var result = managementClient->deleteConsumerGroup("myeventhub", "consumerGroup1");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
    if (result is ()) {
        log:print("successful");
    }
}

# After Suite Function
@test:AfterSuite {}
function afterSuiteFunc() {
    var result = managementClient->deleteEventHub("myeventhub");
    if (result is error) {
        test:assertFail(msg = result.message());
    }
    test:assertTrue(result is ());
}

# Get configuration value for the given key from ballerina.conf file.
# 
# + return - configuration value of the given key as a string
isolated function getConfigValue(string key) returns string {
    return (system:getEnv(key) != "") ? system:getEnv(key) : config:getAsString(key);
}
