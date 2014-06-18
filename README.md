### Inventory CQRS
Simple invetory management application based on a simplified CQRS architecture. I did this project to explain a new coworker the 
architecture of our application using a simple and practical example.

The original implementation is done in javascript, this is just a port for me to learn application development in Ruby.

## Domain

- Item: an object having a name (e.g. Apple, Chair, Cat), a description (e.g. 'Red and juicy', 'Not very comfortable but looks great', '<3')
and a value (e.g. 100.0, 0.35, 12.4).
- Inventory: a named (e.g. Fruits, Furniture, Animals) group of Items.

Or represented more visually:
```
+---------------+          +-----------+
|      Item     |          | Inventory |
+---------------+          +-----------+
| * id          | <---     | * id      |
| * name        |     \    | * name    |
| * value       |      ----| * items   |
| * description |          +-----------+
+---------------+
```

The following actions are available (in the system as commands for the action and events foir the persistence):
- Item:
    * Create
    * Delete
    * Rename
    * Reevaluate

- Inventory:
    * Create
    * Delete
    * Rename
    * Add Item
    * Remove Item

## View

The view model is slightly different to show the benefits of different models on the View side from the Domain.

The Item stays unchanged.

We introduce an ItemRecord being a copy of an item without the description.

The Inventory contains a list of ItemRecord instead of item ids and adds the value fields being the precomputed sum of the value of each of the items it contains.

Again, graphics sometimes help:
```
+---------------+   +------------+
|      Item     |   | ItemRecord |
+---------------+   +------------+
| * id          |   | * id       |
| * name        |   | * name     |
| * value       |   | * value    |
| * description |   +------------+
+---------------+   ^
                   /
+-----------+     |
| Inventory |     |
+-----------+     |
| * id      |     |
| * name    |    /
| * items   | --
+-----------+
```
