import Image from 'next/image';
import Link from 'next/link';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faGlobe, faWandMagicSparkles } from '@fortawesome/free-solid-svg-icons';
import { faWindows, faGithub } from '@fortawesome/free-brands-svg-icons';

export default function Home() {
  return (
    <>
      <section className="section intro" id="home">
        <h1 className="section__title section__title--intro">
          Hi, I am <strong>Oscar Tiego</strong>
        </h1>
        <p className="section__subtitle section__subtitle--intro">full-stack dev</p>
        <Image
          src="/images/hero-bestt.png"
          alt="A picture of Oscar Tiego smiling"
          className="intro__img"
          width={250}
          height={250}
          priority
        />
      </section>

      <section className="section my-services" id="serviced">
        <h2 className="section__title section__title--services">What I do</h2>
        <div className="services">
          <div className="service">
            <FontAwesomeIcon icon={faGlobe} />
            <h3>Web Design</h3>
            <p>
              I design websites sing productivity tools like Figma, Adobe Illustrator and Adobe XD
              to ensure the ultimate user expirience
            </p>
          </div>

          <div className="service">
            <FontAwesomeIcon icon={faWandMagicSparkles} />
            <h3>Web development</h3>
            <p>
              I develop websites using Css, Html, Vanilla Javascript, React.js, with Express.js and
              Node.js
            </p>
          </div>

          <div className="service">
            <FontAwesomeIcon icon={faWindows} />
            <h3>Desktop Development</h3>
            <p>
              I make desktop applications using the PyQt python framework for beautiful user
              interfaces
            </p>
          </div>
        </div>

        <a href="#work" className="btn">
          My Work
        </a>
      </section>

      <section className="section about-me" id="about">
        <h2 className="section__title section__title--about">Who I am</h2>
        <p className="section__subtitle section__subtitle--about">
          Designer & developer based out of Nairobi
        </p>

        <div className="about-me__body">
          <p>
            I am a web and desktop designer with extreme interests in block chain technologies,
            cyber security and database programming
          </p>
          <p>
            I enjoy learning new frameworks and languages like C# and React. On the side i enjoy
            playing chess and building things for fun.
          </p>
        </div>

        <Image
          src="/images/hero-right.png"
          alt="A picture of me"
          className="about-me__img"
          width={200}
          height={200}
        />
      </section>

      <section className="section my-work" id="work">
        <h2 className="section__title section__title--work">My work</h2>
        <p className="section__subtitle section__subtitle--work">A selection of my range of Work</p>

        <div className="portfolios">
          <div className="portfolio-item">
            <div className="image">
              <Image src="/images/item1.svg" alt="Dukas E-Commerce" width={400} height={300} />
            </div>
            <div className="hover-items">
              <h3>Dukas E-Commerce</h3>
              <h3>Project Page</h3>
              <div className="icons">
                <Link
                  href="https://tish254.github.io/Dukas/"
                  className="icon"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <FontAwesomeIcon icon={faGithub} />
                </Link>
              </div>
            </div>
          </div>

          <div className="portfolio-item">
            <div className="image">
              <Image src="/images/item2.svg" alt="Zebraz E-learning" width={400} height={300} />
            </div>
            <div className="hover-items">
              <h3>Zebraz E-learning</h3>
              <h3>Project Page</h3>
              <div className="icons">
                <Link
                  href="https://tish254.github.io/Zebraz/"
                  className="icon"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <FontAwesomeIcon icon={faGithub} />
                </Link>
              </div>
            </div>
          </div>

          <div className="portfolio-item">
            <div className="image">
              <Image src="/images/item3.svg" alt="Akan Name Generator" width={400} height={300} />
            </div>
            <div className="hover-items">
              <h3>Akan Name Generator</h3>
              <h3>Project Page</h3>
              <div className="icons">
                <Link
                  href="https://tish254.github.io/akan-name/"
                  className="icon"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <FontAwesomeIcon icon={faGithub} />
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
