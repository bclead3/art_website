$(document).ready(function(e) {
    let slideIndex = 1;
    showSlides(slideIndex);

    function showSlides(n) {
        console.log("Within showSlides n=" + n)
        let i;
        let slides = document.getElementsByClassName('carousel-item');
        let slideIndex = 0

        if (n > slides.length) {
            slideIndex = 1
        }
        if (n < 1) {
            slideIndex = slides.length
        }
        for (i = 0; i < slides.length; i++) {
            slides[i].setAttribute('style', 'display:none;')
        }

        let slide = slides[slideIndex -1]
        if (slide) slide.setAttribute('style', 'display:block;')

        let dots = document.getElementsByClassName('dot');
        console.log('The number of dots is:' + dots.length);
        for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i].className.replace(' active', '');
        }
        let dotIndex = slideIndex - 1
        for (i = 0; i < dots.length; i++) {
            if (i === dotIndex) {
                dots[i].className += " active";
            }
        }
    }

    function plusSlides(n) {
        console.log("within plusSlides with n=" + n)
        showSlides(slideIndex += n);
    }

    function currentSlide(n) {
        console.log("within currentSlide with n:"+n)
        showSlides(slideIndex = n);
    }

    $('.carousel-control-prev').on('click', function() {
        plusSlides(-1)
    })
    $('.carousel-control-next').on('click', function() {
        plusSlides(1)
    })

    $('span.dot').on('click', function (){
        let dotIndex = $(this).attr('data')
        console.log("dot click"+dotIndex)
        currentSlide(dotIndex)
    })

    $('#painting_category_id').on('change', function(){
        console.log('change gives '+this.value);
    })
})