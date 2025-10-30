'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBars, faXmark } from '@fortawesome/free-solid-svg-icons';
import { useUser } from '@/lib/supabase/provider';

export default function Header() {
  const { user } = useUser();
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const [activeSection, setActiveSection] = useState('home');

  useEffect(() => {
    const handleScroll = () => {
      const sections = document.querySelectorAll('.section');
      const scrollPosition = window.pageYOffset;

      sections.forEach((section) => {
        const sectionTop = (section as HTMLElement).offsetTop;
        const sectionHeight = (section as HTMLElement).clientHeight;
        const sectionId = section.getAttribute('id');
        const calc = sectionTop - sectionHeight / 4;

        if (scrollPosition >= calc && sectionId) {
          setActiveSection(sectionId);
        }
      });

      const totalPageHeight = document.body.scrollHeight;
      const scrollPoint = window.scrollY + window.innerHeight;

      if (scrollPoint >= totalPageHeight) {
        setActiveSection('footer');
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const toggleMobileNav = () => {
    setMobileNavOpen(!mobileNavOpen);
  };

  const closeMobileNav = () => {
    setMobileNavOpen(false);
  };

  const navLinks = [
    { href: '#home', label: 'Home', id: 'home' },
    { href: '#serviced', label: 'Services', id: 'serviced' },
    { href: '#about', label: 'About me', id: 'about' },
    { href: '#work', label: 'Work', id: 'work' },
    { href: '#footer', label: 'Contact', id: 'footer' },
  ];

  return (
    <header id="#home-header">
      <div className="nav-container">
        <div className="nav-logo">
          <Link href="/">
            <Image src="/images/dev-tish.png" alt="DevTish Logo" width={150} height={40} priority />
          </Link>
        </div>
        <div className="nav-bar">
          <ul className="nav-list">
            {navLinks.map((link) => (
              <li key={link.id} className="nav-item">
                <a
                  href={link.href}
                  className={`nav-link ${link.id} ${activeSection === link.id ? 'active' : ''}`}
                >
                  {link.label}
                </a>
              </li>
            ))}
          </ul>
        </div>
      </div>

      <div className="mobile-nav-container">
        <div className="logo">
          <Link href="/">
            <Image src="/images/dev-tish.png" alt="DevTish Logo" width={120} height={32} priority />
          </Link>
        </div>

        <nav id="nav-id" className={`nav ${mobileNavOpen ? 'mobile-display' : ''}`}>
          <ul className="nav__list">
            {navLinks.map((link) => (
              <li key={link.id} className="nav__item">
                <a
                  href={link.href}
                  className={`nav__link ${link.id} ${activeSection === link.id ? 'active-mobile' : ''}`}
                  onClick={closeMobileNav}
                >
                  {link.label}
                </a>
              </li>
            ))}
          </ul>
        </nav>

        <div className="nav-toggle" onClick={toggleMobileNav}>
          <FontAwesomeIcon icon={mobileNavOpen ? faXmark : faBars} />
        </div>
      </div>
    </header>
  );
}
