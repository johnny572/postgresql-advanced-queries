 maximize_prime_inventory.sql
"Add Amazon SQL interview solution: Maximize Prime Item Inventory"


/*
Problem: Maximize Prime Item Inventory
---------------------------------------
Amazon wants to maximize the storage capacity of its 500,000 sq-ft warehouse
by prioritizing prime item batches. Prime batches come together, non-prime batches come later.

Assumptions:
1. Products must be stocked in batches.
2. Non-prime items must always be stocked.
3. Item count should be whole numbers.

Solution Approach:
- Step 1: Group items into batches
- Step 2: Sum square footage per batch set
- Step 3: Calculate max prime batches
- Step 4: Allocate remaining space to non-prime batches
- Step 5: Output item count per type

SQL Solution:
*/

WITH batch_level AS (
    SELECT
        item_type,
        item_category,
        COUNT(item_id)      AS items_in_batch,
        SUM(square_footage) AS batch_sqft
    FROM inventory
    GROUP BY item_type, item_category
),
batch_set AS (
    SELECT
        item_type,
        SUM(batch_sqft)     AS batch_set_sqft,
        SUM(items_in_batch) AS items_per_set
    FROM batch_level
    GROUP BY item_type
),
prime_calc AS (
    SELECT
        FLOOR(500000 / batch_set_sqft) AS prime_sets,
        batch_set_sqft,
        items_per_set
    FROM batch_set
    WHERE item_type = 'prime_eligible'
),
remaining_space AS (
    SELECT
        500000 - (prime_sets * batch_set_sqft) AS remaining_sqft
    FROM prime_calc
),
non_prime_calc AS (
    SELECT
        FLOOR(r.remaining_sqft / b.batch_set_sqft) AS non_prime_sets,
        b.items_per_set
    FROM remaining_space r
    JOIN batch_set b
      ON b.item_type = 'not_prime'
)
SELECT
    'prime_eligible' AS item_type,
    prime_sets * items_per_set AS item_count
FROM prime_calc
UNION ALL
SELECT
    'not_prime',
    non_prime_sets * items_per_set
FROM non_prime_calc;
