import React from "react";

const Header = () => {
  return (
    <header className="header">
      <div className="header-container">
        <div className="logo-section">
          <div className="logo-icon">🛡️</div>
          <div className="logo-text">InsureFlow</div>
        </div>
        <nav>
          <ul className="nav-links">
            <a href="#plans">Plans</a>
            <a href="#coverage">Coverage</a>
            <a href="#testimonials">Reviews</a>
            <a href="#contact">Contact</a>
          </ul>
        </nav>
      </div>
    </header>
  );
};

export default Header;
