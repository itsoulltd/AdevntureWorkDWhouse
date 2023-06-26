### Setting up the project:
    ~> cd <to-project-root>
    ~> mkdir AdventureWorks

### Download AdventureWorks Databases from [Here](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms)
### Then place databases in AdventureWorks dir:
    ~> mv ~/Downloads/AdventureWorks2022.bak ../<Project-Root>/AdevntureWorks/

### How to Run: (Docker Engine must be installed)

    ~> open -a Docker
    ~> docker-compose up -d

### Open up SQL Server Management Studio and Connect as follows:
    Server type: Database Engine
    Server name: localhost
    Authentication: SQL Server Authentication
    Login: sa
    Password: SA@12345

### How to import follow [Here](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms#restore-to-sql-server)
### END Of Line