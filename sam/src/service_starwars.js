'use strict';

const aws = require('aws-sdk');

const StarWarsTableName = process.env.TABLE_NAME;

exports.createFigure = async (figure) => {
  const params = {
    TableName: StarWarsTableName,
    Item: figure
  };

  const dynamoDB = new aws.DynamoDB.DocumentClient();
  try {
    await dynamoDB.put(params).promise();
  } catch (error) {
    console.log(`Failed to create Star Wars Action Figure: ${error}`);
    throw error;
  }
};

exports.getFigure = async (id) => {
  const params = {
    TableName: StarWarsTableName,
    Key: {
      Id: id
    }
  };

  const dynamoDB = new aws.DynamoDB.DocumentClient();
  try {
    const result = await dynamoDB.get(params).promise();
    return result.Item === undefined ? null : result.Item;
  } catch (error) {
    console.log(`Failed to get Star Wars Action Figure with id "${id}": ${error}`);
    throw error;
  }
};

exports.listFigures = async () => {
  const params = {
    TableName: StarWarsTableName
  };

  const dynamoDB = new aws.DynamoDB.DocumentClient();
  try {
    const results = await dynamoDB.scan(params).promise();
    return results.Items;
  } catch (error) {
    console.log(`Failed to fetch Star Wars Action Figure: ${error}`);
    throw error;
  }
};

exports.updateFigure = async (id, figure) => {
  figure.Id = id;
  const params = {
    TableName: StarWarsTableName,
    Item: figure
  };

  const dynamoDB = new aws.DynamoDB.DocumentClient();
  try {
    const result = await dynamoDB.put(params).promise();
    return results.Item;
  } catch (error) {
    console.log(`Failed to update Star Wars Action Figure with id "${id}": ${error}`);
    throw error;
  }
};

exports.deleteFigure = async (id) => {
  const params = {
    TableName: StarWarsTableName,
    Key: {
      Id: id
    }
  };

  const dynamoDB = new aws.DynamoDB.DocumentClient();
  try {
    await dynamoDB.delete(params).promise();
  } catch (error) {
    console.log(`Failed to delete Star Wars Action Figure with id "${id}": ${error}`);
    throw error;
  }
};
