import ballerinax/azure_eventhub;
import ballerina/config;
import ballerina/log;

public function main() {
    azure_eventhub:ClientEndpointConfiguration config = {
        sasKeyName: config:getAsString("SAS_KEY_NAME"),
        sasKey: config:getAsString("SAS_KEY"),
        resourceUri: config:getAsString("RESOURCE_URI") 
    };
    azure_eventhub:PublisherClient publisherClient = new (config);
    
    var result = publisherClient->send("myeventhub", "eventData");
    if (result is error) {
        log:printError(msg = result.message());
    } else {
        log:print("Successful!");
    }
}
