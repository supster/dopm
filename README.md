Digital Ocean Package Manager
=============

Environment Setup
-----------------
### Runtime

The code is developed using Ruby 2.3.1.  The Ruby runtime is needed to run the program.

### Running the server

If [port] is not supplied, 8080 will be used.

    ./run.rb [port]

### Save data

Press Shift+S key to save data to packages.txt

### Save and Exit

Press Shift+Q key to save data to packages.txt and exit the program

Design Rationale and Approach
-----------------

* I started with writing ServerTest that created a fake Client that sent 'PING' and expected to receive 'PONG'.
* Then, I created a Server class that satisfied the test.
* After that, I started working on receiving the real requests according to the instruction/specification.
* The responsibility of parsing and indexing requests needed its own class, so I created Indexer.
* I use in-memory hash as a data storage, but it can be persisted in a txt file using Save or Quit commands.