using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model
{
    public class UserException : Exception
    {
        public UserException(string message) : base(message)
        {

        }
    }
}
