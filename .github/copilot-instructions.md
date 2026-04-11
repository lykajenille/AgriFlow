# GitHub Copilot Instruction: Concise, Low-Hallucination Coding Guidelines

## Objective

Ensure all generated code and suggestions are:

* Accurate and grounded
* Concise and minimal
* Free from unnecessary complexity (overengineering)
* Optimized to reduce premium request usage

---

## Tech Stack Context (IMPORTANT)

* **Frontend / Mobile:** Dart & Flutter
* **Backend:** PHP (Laravel preferred if applicable)

> Always prioritize solutions compatible with this stack.
> Do NOT introduce other frameworks or languages unless explicitly requested.

---

## Core Rules

### 1. Avoid Hallucinations

* Do NOT invent APIs, libraries, functions, or parameters.
* Only use:

  * Dart / Flutter official SDK & common packages
  * PHP native or Laravel features (if project uses Laravel)
* If unsure:

  * Add a TODO instead of guessing

---

### 2. Be Concise

* Provide the **simplest working solution**.
* Avoid:

  * Verbose comments
  * Boilerplate-heavy structures
* Keep:

  * Flutter widgets minimal
  * PHP controllers/services lean

---

### 3. Avoid Overengineering

* Do NOT introduce:

  * Complex state management (Bloc, Riverpod, etc.) unless already used
  * Repository/service layers unless necessary
* Prefer:

  * `setState` or simple state handling (Flutter)
  * Direct controller logic (PHP)

---

### 4. Respect Existing Context

* Follow:

  * Existing Flutter project structure
  * Existing Laravel/PHP conventions
* Do NOT:

  * Add new architecture patterns without need
  * Replace working implementations

---

### 5. Minimize Token / Request Usage

* Generate:

  * Only necessary code
  * No long explanations
* Prefer:

  * Snippets over full files
  * Focused updates

---

### 6. Handle Uncertainty Properly

If requirements are unclear:

```
 // TODO: Confirm requirement for [specific behavior]
```

---

## Flutter-Specific Guidelines

* Use:

  * StatelessWidget when possible
  * StatefulWidget only when needed
* Avoid:

  * Deep widget nesting
* Keep UI:

  * Simple and readable

### Example (Good)

```
Text('Hello World')
```

### Example (Bad - Overbuilt)

```
Container(
  child: Center(
    child: Text(
      'Hello World',
      style: TextStyle(fontSize: 16),
    ),
  ),
)
```

---

## PHP / Laravel Guidelines

* Prefer:

  * Simple controller methods
  * Built-in Laravel features (validation, Eloquent)
* Avoid:

  * Unnecessary service classes
  * Overly abstracted logic

### Example (Good)

```
return User::where('active', 1)->get();
```

### Example (Bad)

```
$this->userRepository->getActiveUsersWithCustomQueryBuilder();
```

---

## Error Handling

* Add only **practical error handling**
* Example:

```
if (!$user) {
  return response()->json(['error' => 'User not found'], 404);
}
```

---

## Performance

* Default to readable code
* Optimize only if required

---

## Summary

> “Use Dart/Flutter for frontend, PHP for backend.
> Write the simplest correct solution.
> Do not guess. Do not overbuild. Keep it minimal.”

---
