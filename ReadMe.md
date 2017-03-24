## Synopsis

This project was created so that I could have more control over actions taken when Active Directory logon scripts were ran. I wanted 
to be able to not just run commands at logon, but also later in the day or on other days. Basically needed to have the user profiles 
continually phoning home and looking for tasks assigned to them.

## Code Example

You'll have to check out my blog post, it's the only time I used this and it's the only documentation or example I have of this type of
setup. That is up at: https://gregbesso.wordpress.com/powershell/powershell-perpetual-login-script/

## Motivation

There was a project where we needed to perform a task at the same time across all workstations but within the user session. I chose to use 
an AD logon script but keep the session alive for as long as needed to go back and touch the user sessions when needed.


## Installation

This project includes 5 files that are placed on a UNC network share path just like any other AD logon script. 

## API Reference

No API here. <sounds of crickets>

## Tests

No testing info here. <sounds of crickets>

## Contributors

Just a solo script project by moi, Greg Besso. Hi there :-)

## License

Copyright (c) 2017 Greg Besso

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.