var STAR_WARS = "Star Wars";
var THE_EMPIRE_STRIKES_BACK = "The Empire Strikes Back";
var RETURN_OF_THE_JEDI = "Return of the Jedi";

var starWarsArr = new Array();
var empireArr = new Array();
var returnArr = new Array();

var COLLECTION_TOTAL_STAR_WARS = 20;
var COLLECTION_TOTAL_EMPIRE = 30;
var COLLECTION_TOTAL_RETURN = 28;

var COLLECTION_ACTUAL_STAR_WARS = new Array();
var COLLECTION_ACTUAL_EMPIRE = new Array();
var COLLECTION_ACTUAL_RETURN = new Array();

getFigures();

function partitionByMovie(figureArr) {
  $.each(figureArr, function( i, figure ) {
    switch(figure.Movie) {
      case STAR_WARS:
          COLLECTION_ACTUAL_STAR_WARS.push(figure);
          break;
      case THE_EMPIRE_STRIKES_BACK:
          COLLECTION_ACTUAL_EMPIRE.push(figure);
          break;
      case RETURN_OF_THE_JEDI:
          COLLECTION_ACTUAL_RETURN.push(figure);
          break;
      default:
          console.log("WARNING >> " + figure.movie + " not found!");
          break;
    }
  });
}

function renderGridByMovie(movieArr, renderComponent){
  var sortedFigures = sortByKey(movieArr, 'Name');
  $.each(sortedFigures, function( i, figure ) {
    var figureHtml = '';
    figureHtml += '<div class="col-lg-3 col-md-4 col-xs-6 thumb">';
    figureHtml += '<a class="thumbnail" href="#">';
    figureHtml += '<img class="img-responsive" src="'+IMAGE_BUCKET_URL+figure.Image+'" alt="'+figure.Name+'">';
    figureHtml += '</a>';
    figureHtml += '<p style="text-align: center">'+figure.Name+'</p>';
    figureHtml += '</div>';
    $(renderComponent).append(figureHtml);
  });
}

function renderTableByMovie(movie, movieArr, totalArr, calculateTotals) {
  var acquiredFigures = (calculateTotals) ? COLLECTION_ACTUAL_STAR_WARS.length+COLLECTION_ACTUAL_EMPIRE.length+COLLECTION_ACTUAL_RETURN.length : movieArr.length;
  var completionPercentage = Math.round((acquiredFigures/totalArr)*100);
  $('#acquired-figures-'+movie).html(acquiredFigures);
  $('#remaining-figures-'+movie).html(totalArr - acquiredFigures);
  $('#total-figures-'+movie).html(totalArr);
  $('#completion-percent-'+movie).html(completionPercentage+'%');
  $('#completion-percent-'+movie).css('width', completionPercentage+'%').attr('aria-valuenow', completionPercentage);
  switch(true) {
    case (completionPercentage == 100):
        $('#completion-percent-'+movie).addClass('progress-bar-success');
        break;
    case (completionPercentage > 75):
        $('#completion-percent-'+movie).addClass('progress-bar-info');
        break;
    case (completionPercentage > 50):
        $('#completion-percent-'+movie).addClass('progress-bar-warning');
        break;
    default:
      $('#completion-percent-'+movie).addClass('progress-bar-danger');
      break;
  }
}

function sortByKey(array, key) {
  return array.sort(function(a, b) {
      var x = a[key]; var y = b[key];
      return ((y > x) ? -1 : ((y < x) ? 1 : 0));
  });
}

function getFigures() {
  $.get(API_GATEWAY_URL)
    .done(function(data) {
      renderUserInterface(data);
    })
    .fail(function() {
      alert( "error" );
    });
}

function renderUserInterface(data) {
  partitionByMovie(data);
  // render grid
  renderGridByMovie(COLLECTION_ACTUAL_STAR_WARS, '.figure-gallery-star-wars');
  renderGridByMovie(COLLECTION_ACTUAL_EMPIRE, '.figure-gallery-empire');
  renderGridByMovie(COLLECTION_ACTUAL_RETURN, '.figure-gallery-return');

  // render table
  renderTableByMovie('star-wars', COLLECTION_ACTUAL_STAR_WARS, COLLECTION_TOTAL_STAR_WARS, false);
  renderTableByMovie('empire', COLLECTION_ACTUAL_EMPIRE, COLLECTION_TOTAL_EMPIRE, false);
  renderTableByMovie('return', COLLECTION_ACTUAL_RETURN, COLLECTION_TOTAL_RETURN, false);
  renderTableByMovie('total', "", (COLLECTION_TOTAL_STAR_WARS+COLLECTION_TOTAL_EMPIRE+COLLECTION_TOTAL_RETURN), true);
}
