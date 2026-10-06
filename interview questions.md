# Flutter Mid-Level Developer Interview

**Duration:** 60 minutes  
**Format:** Practical coding followed by a brief discussion  
**Questions:** Complete questions 1 and 2, then choose either question 3 or question 4.

The document contains four questions. Candidates complete three during the interview so there is time to assess both implementation and reasoning.

## Interview schedule

| Activity | Time |
| --- | --- |
| Introductions, instructions, and choosing question 3 or 4 | 5 minutes |
| Question 1: Algorithm — medium | 10 minutes |
| Question 2: Registration form and API integration — medium | 20 minutes |
| Question 3 or 4: Advanced Flutter task — difficult | 20 minutes |
| Code walkthrough and discussion | 5 minutes |
| **Total** | **60 minutes** |

## Preparation and candidate instructions

- Provide a running Flutter starter application before the interview. Project creation and dependency installation are outside the 60 minutes.
- Include `http` or `Dio` and allow the candidate's preferred state-management approach. No particular package is required.
- Provide product data and the asynchronous search repository described in question 3. Provide basic screen scaffolding for both difficult options.
- Verify access to the dummy API before the interview. If the public service is unavailable, provide a local equivalent and assess the same request/response behaviour.
- Candidates may consult official documentation. Prioritize working behaviour and clear reasoning over visual polish.
- Use fictional registration details and a test password.

## Question 1: Merge overlapping booking intervals

**Difficulty:** Medium  
**Time:** 10 minutes

Write a Dart function that accepts a list of booking intervals and returns a sorted list with overlapping intervals merged. No Flutter screen is required.

```dart
Input:  [[8, 10], [1, 3], [2, 6], [9, 12]]
Output: [[1, 6], [8, 12]]
```

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

## Question 3: Searchable product list with async state handling

**Difficulty:** Difficult  
**Time:** 20 minutes  
**Selection:** Choose this question OR question 4.

Build a product search screen using a supplied repository. The repository simulates variable response times, so responses may arrive out of order.

```dart
Future<List<Product>> searchProducts(String query);

// Product fields: id, name, priceInMinorUnits
```

The interviewer supplies this repository with sample products and a documented query that triggers an error. Candidates do not implement the repository.

**Discussion extension:** How would you add pagination, prevent duplicate page requests, and retain existing results if the next page fails?

## Question 4: Shopping cart with shared and derived state

**Difficulty:** Difficult  
**Time:** 20 minutes  
**Selection:** Choose this question OR question 3.

Build a product list and cart screen using supplied local product data. Show a cart-count badge on the product screen. The interviewer provides basic screen scaffolding and product data; the candidate implements cart behaviour.

```dart
// Product fields: id, name, priceInMinorUnits, availableStock
// Prices use integer minor units; do not calculate money using double.
```
