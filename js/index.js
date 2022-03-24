let toggled = false;

const navToggle = document.querySelector('.nav-toggle');

const navLinks = document.querySelectorAll('.nav__link');

const nav_links = document.querySelectorAll('.nav-link');

const sections = document.querySelectorAll('.section');


navLinks.forEach( (link) => {
    link.addEventListener('click', (event)=> {

        document.getElementById('nav-change').classList.remove('fa-xmark');
        document.getElementById('nav-change').classList.add('fa-bars');

        document.querySelector('.active-mobile').classList.remove('active-mobile')
        event.target.classList.add('active-mobile')
        removeMobileNav(toggled);
        toggled = false;
    })
})

nav_links.forEach((link) => {
    link.addEventListener('click', (event)=> {
        document.querySelector('.active').classList.remove('active')
        event.target.classList.add('active')
    })
})

window.addEventListener("scroll", (event) => {
    let current = '';
    sections.forEach( section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        let calc = sectionTop - sectionHeight/4;
        if (pageYOffset >= calc) {
            const sectionName = section.getAttribute('id');
            navLinks.forEach( link => {
                if (link.classList.contains(sectionName)) {
                    document.querySelector('.active-mobile').classList.remove('active-mobile')
                    link.classList.add('active-mobile')
                }
            })
        }
    })
})

window.addEventListener("scroll", (event) => {
    let current = '';
    sections.forEach( section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        let calc = sectionTop - sectionHeight/4;
        if (pageYOffset >= calc) {
            const sectionName = section.getAttribute('id');
            nav_links.forEach( link => {
                if (link.classList.contains(sectionName)) {
                    document.querySelector('.active').classList.remove('active')
                    link.classList.add('active')
                }
            })
        }
    })
})


let totalPageHeight = document.body.scrollHeight; 

let scrollPoint = window.scrollY + window.innerHeight;

if(scrollPoint >= totalPageHeight)

window.onscroll = function(ev) {
    let totalPageHeight = document.body.scrollHeight; 

    let scrollPoint = window.scrollY + window.innerHeight;

    if(scrollPoint >= totalPageHeight) {
        let elem = document.querySelector('.nav__link.contact');
        document.querySelector('.active-mobile').classList.remove('active-mobile')
        elem.classList.add('active-mobile')
    }
};

window.onscroll = function(ev) {
    let totalPageHeight = document.body.scrollHeight; 

    let scrollPoint = window.scrollY + window.innerHeight;

    if(scrollPoint >= totalPageHeight) {
        let elem = document.querySelector('.nav-link.contact');
        document.querySelector('.active').classList.remove('active')
        elem.classList.add('active')
    }
};

function navToggleClicked() {
    // alert('window toggled');


    if (!toggled) {

        document.getElementById('nav-change').classList.remove('fa-bars');
        document.getElementById('nav-change').classList.add('fa-xmark');

        removeMobileNav(toggled);

        toggled = true;

    } else {

        document.getElementById('nav-change').classList.remove('fa-xmark');
        document.getElementById('nav-change').classList.add('fa-bars');

        removeMobileNav(toggled);
        
        toggled = false;
    }
}

function removeMobileNav(toggled) {
    if (!toggled) {
        document.getElementById('nav-id').classList.add('mobile-display');
    
    } else {
        document.getElementById('nav-id').classList.remove('mobile-display');
    }
}


