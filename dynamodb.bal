import ballerinax/aws.dynamodb;
import ballerina/os;
import ballerina/log;

dynamodb:ConnectionConfig amazonDynamodbConfig = {
    awsCredentials: {
        accessKeyId: os:getEnv("ACCESS_KEY_ID"),
        secretAccessKey: os:getEnv("SECRET_ACCESS_KEY")
    },
    region: os:getEnv("AWS_DEFAULT_REGION")
};

dynamodb:Client amazonDynamodbClient = check new (amazonDynamodbConfig);

function persist(Breed[] breeds) returns boolean|error {
    foreach var breed in breeds {
        dynamodb:ItemCreateInput createItemInput = {
            tableName: "dogs",
            item: {
                "Id": {"N": breed.id.toString()},
                "Name": {"S": breed.name},
                "Lifespan": {"S": breed.life_span}
            }
        };
        dynamodb:ItemDescription response = check amazonDynamodbClient->createItem(createItemInput);
        log:printInfo(response.toString());
    }
    return true;
}