import React from 'react';

const NavUserProfile = (props) => {
  const {
    email,
    logout_url
  } = props;
  
  if(email == null) {
    return null;
  }

  return (
  
  <li className="nav-item dropdown">
    <a
      className="nav-link dropdown-toggle"
      data-toggle="dropdown"
      aria-haspopup="true"
      aria-expanded="false"
    >
      <i className="fa fa-user-circle mr-1"></i>
      {email}
    </a>
    <div className="dropdown-menu" aria-labelledby="dropdown01">
      <a
        href={logout_url}
        data-method="delete"
        className='dropdown-item'
      >
        Logout
      </a>
    </div>
  </li>
)};

export default NavUserProfile;

