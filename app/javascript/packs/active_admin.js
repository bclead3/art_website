require "https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"

$(document).ready(function(e) {
    $('#painting_category_id').on('change', function(){
        console.log('change gives '+this.value);
    })
})