import Link from 'next/link';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faFacebook, faLinkedin, faTwitter, faGithub } from '@fortawesome/free-brands-svg-icons';

export default function Footer() {
  const socialLinks = [
    {
      href: 'https://www.facebook.com/oscar.tiego.92/',
      icon: faFacebook,
      label: 'Facebook',
    },
    {
      href: 'https://www.linkedin.com/in/oscar-tiego-b1b190171',
      icon: faLinkedin,
      label: 'LinkedIn',
    },
    {
      href: 'https://twitter.com/py12317',
      icon: faTwitter,
      label: 'Twitter',
    },
    {
      href: 'https://github.com/Tish254',
      icon: faGithub,
      label: 'GitHub',
    },
  ];

  return (
    <footer className="footer" id="footer">
      <a href="mailto:tiegomseeraoscar295@gmail.com" className="footer__link">
        tiegomseeraoscar295@gmail.com
      </a>
      <ul className="social-list">
        {socialLinks.map((link) => (
          <li key={link.label} className="social-list__item">
            <Link
              href={link.href}
              className="social-list__link"
              target="_blank"
              rel="noopener noreferrer"
            >
              <FontAwesomeIcon icon={link.icon} className="social-icon" />
            </Link>
          </li>
        ))}
      </ul>
    </footer>
  );
}
