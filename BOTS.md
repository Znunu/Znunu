## Interfaces

#### Input/Output
- Messages
- Bot owners and devs

#### Output
- Channel, Server, Role names etc
- 3rd party websites

#### Input
- Docs, Repos etc

## Vulnerabilities
- Unsafe `eval`, `calc`, `calculate` etc
- Unfiltered @everyone, @here etc
- CPU intensive commands
- Synchronous code
- Token leak

## Ideas
Scrape places like github, repl and try to match token regex


Run unsafe commands against built-ins (`Math.E`, `abs(-1)` etc)


Parse help command, extract commands and try to run them all, with 1, 2 and 3 random params, urls or mentions. Measure the deviance between response times.
