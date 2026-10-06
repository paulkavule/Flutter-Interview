## Question 2: Registration form with dummy API integration

**Difficulty:** Medium  
**Time:** 20 minutes

Build a registration screen for individual and business accounts. Submit valid data to the DummyJSON API using `http` or `Dio`.

### API details

| Item | Value |
| --- | --- |
| Method | `POST` |
| URL | `https://dummyjson.com/users/add` |
| Content type | `application/json` |
| Documentation | [DummyJSON users documentation](https://dummyjson.com/docs/users) |
| Behaviour | Simulates user creation and returns submitted data with a new ID; the user is not permanently saved. |

Example request for a business account:

```json
{
  "firstName": "Jane",
  "lastName": "Doe",
  "email": "jane@example.com",
  "password": "Test1234!",
  "company": {
    "name": "Example Company"
  }
}
```