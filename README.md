# TODO app

## Environment Variables
| **NAME**           | **DEFAULT** |
| :----------------- | :---------- |
| **`TODO_DB`**      | `todo.db`   |
| **`TODO_PORT`**    | `:8000`     |
| **`TODO_LIMIT`**   | `20`        |

## Query Parameters
| **NAME**           | **TYPE**                   |
| :----------------- | :------------------------- |
| **`due:gt`**       | **RFC-3339 DATETIME**      |
| **`due:gte`**      | **RFC-3339 DATETIME**      |
| **`due:lt`**       | **RFC-3339 DATETIME**      |
| **`due:lte`**      | **RFC-3339 DATETIME**      |
| **`state`**        | **[todo,in_process,done]** |
| **`page`**         | **int**                    |
| **`count`**        | **int**                    |

## Example Requests

```bash
GET /?due:gt=2019-10-29T23:09:06Z&due:lt=2019-10-29T23:09:26Z&state=todo&state=done&page=1&count=20
```


- ID
- Description
- Due Date
- State: todo, in-progress, done
    
```bash
docker-compose up -d    # start
docker-compose down 	# stop
```

## Tests
```bash
go test 					# Run entire test suite 
go test -run TestRegex -v 	# Run single test in verbose mode
```

## NOTES:
Comparing Due dates with time.Unix(). Fix!
