import ballerina/http;
import ballerina/os;

type Breed readonly & record {
    int id;
    string name;
    string life_span;
};


service / on new http:Listener(9090) {

    resource function get breeds_json() returns json|error? {
        http:Client jcClient = check new ("https://api.thedogapi.com/");

        json breeds = check jcClient->/v1/breeds('limit = 3, has_breeds=1, headers = {
            "x-api-key": os:getEnv("THE_DOG_API_KEY")
        });

        return breeds;
    }

    resource function get breeds_record() returns Breed[]|error? {
        http:Client jcClient = check new ("https://api.thedogapi.com/");

        Breed[] breeds = check jcClient->/v1/breeds('limit = 3, has_breeds=1, headers = {
            "x-api-key": os:getEnv("THE_DOG_API_KEY")
        });

        // int result = check persist(breeds);

        // return result;
        return breeds;
    }

    resource function get breeds_and_persist() returns boolean|error? {
        http:Client jcClient = check new ("https://api.thedogapi.com/");

        Breed[] breeds = check jcClient->/v1/breeds('limit = 3, has_breeds=1, headers = {
            "x-api-key": os:getEnv("THE_DOG_API_KEY")
        });

        var result = check persist(breeds);

        return result;
    }

    resource function get image/[string id]() returns json|error? {
        http:Client jcClient = check new ("https://api.thedogapi.com/");

        json response = check jcClient->/v1/images/[id](headers = {
            "x-api-key": os:getEnv("THE_DOG_API_KEY")
        });

        return response;
    }
}
