'use strict';

const service = require('./service_starwars.js');

exports.listFigures = async (event) => {
  const figures = await service.listFigures();

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': '*',
      'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
      'Access-Control-Allow-Origin': 'http://dcorp.info',
      'Access-Control-Allow-Methods': 'GET,OPTIONS'
    },
    body: JSON.stringify(figures, null, 2)
  };
};

exports.createFigure = async (event) => {
  const hostname = event.headers.Host;
  const path = event.requestContext.path;

  let figure = JSON.parse(event.body);

  await service.createFigure(figure);
  return {
    statusCode: 201,
    headers: {
      'Location': `https://${hostname}${path}/${figure.id}`,
      'X-Requested-With': '*',
      'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
      'Access-Control-Allow-Origin': 'http://dcorp.info',
      'Access-Control-Allow-Methods': 'POST,OPTIONS'
    }
  };
};

exports.getFigure = async (event) => {
  const id = event.pathParameters.id;

  const figure = await service.getFigure(id);
  if (figure === null) {
    return {
      statusCode: 404,
      headers: {
        'X-Requested-With': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
        'Access-Control-Allow-Origin': 'http://dcorp.info',
        'Access-Control-Allow-Methods': 'GET,OPTIONS'
      } 
    };
  }

  return {
    statusCode: 200,
    headers: {
      'X-Requested-With': '*',
      'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
      'Access-Control-Allow-Origin': 'http://dcorp.info',
      'Access-Control-Allow-Methods': 'GET,OPTIONS'
    },
    body: JSON.stringify(figure, null, 2)
  };
};

exports.updateFigure = async (event) => {
  const id = event.pathParameters.id;

  if (await service.getFigure(id) === null) {
    return {
      statusCode: 404,
      headers: {
        'X-Requested-With': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
        'Access-Control-Allow-Origin': 'http://dcorp.info',
        'Access-Control-Allow-Methods': 'PUT,OPTIONS'
      }
    };
  }

  let figure = JSON.parse(event.body);

  await service.updateFigure(id, figure);

  return {
    statusCode: 200,
    headers: {
      'X-Requested-With': '*',
      'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
      'Access-Control-Allow-Origin': 'http://dcorp.info',
      'Access-Control-Allow-Methods': 'PUT,OPTIONS'
    }
  };
};

exports.deleteFigure = async (event) => {
  const id = event.pathParameters.id;

  if (await service.getFigure(id) === null) {
    return {
      statusCode: 404,
      headers: {
        'X-Requested-With': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
        'Access-Control-Allow-Origin': 'http://dcorp.info',
        'Access-Control-Allow-Methods': 'DELETE,OPTIONS'
      } 
    };
  }

  await service.deleteFigure(id);

  return {
    statusCode: 200,
    headers: {
      'X-Requested-With': '*',
      'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,x-requested-with',
      'Access-Control-Allow-Origin': 'http://dcorp.info',
      'Access-Control-Allow-Methods': 'DELETE,OPTIONS'
    }
  };
};
