# Lab 6 - Recursive SQL

Grading: 3pt

## Setup

Download and run the docker container as usual

````
docker run -p 5432:5432 fiitpdt/postgres-recursive
````

# Labs

1. Write a recursive query which returns a number and its factorial for all
   numbers up to 10. :coffee:

   ```
      ------------
      | 0  | 1   |
      | 1  | 1   |
      | 2  | 2   |
      | 3  | 6   |
      | 4  | 24  |
      | 5  | 120 |
      ...
   
   ```

2. Write a recursive query which returns a number and the number in Fibonacci
   sequence at that position for the first 20 Fibonacci numbers. :coffee::coffee:

   ```
      ------------
      | 1  | 1   |
      | 2  | 2   |
      | 3  | 3   |
      | 4  | 5   |
      | 5  | 8   |
      | 6  | 13  |
      | 7  | 21  |
      ...
   
   ```

3. Table `product_parts` contains products and product parts which are needed to build them. A product part may be used to assemble another product part or product, this is stored in the `part_of_id` column. When this column contains `NULL` it means that it is the final product. List all parts and their components that are needed to build a `'chair'`. :coffee::coffee:

   ```
       ------------
       "armrest"
       "metal leg"
       "metal rod"
       "cushions"
       "red dye"
       "cotton"
       ------------
   ```

4. List all bus stops between 'Zochova' and 'Zoo' for line 39. Also include the hop number on that trip between the two stops. :coffee::coffee:

   ```
       ------------------------------
        name         | hop
       ------------------------------
        Chatam Sófer | 1
        Park kultúry | 2
        Lafranconi   | 3
       ------------------------------  
   ```

## Optional

1. Which one of all the parts that are used to build a `'chair'` has longest shipping time? :coffee::coffee:

   ```
       ------------------------------
        name         | shipping_time
       ------------------------------
        metal rod    | 10
       ------------------------------    
   ```

2. Is it cheaper to order a finished chair from a supplier or is it cheaper if we order the basic components of a chair and build it from scratch? We are only interested in the basic components, e.g., to build a chair we need an armrest, but we do not care about its price since we want to build it from scratch using cotton and red dye. :coffee::coffee::coffee:

   ```
       --------------------------------------
        chair_price_from_basic | chair_price
       --------------------------------------
        14                     | 130          
       --------------------------------------
   ```

3. Find line combinations which will get me from 'Nad lúčkami' to 'Zochova' with reasonable transfers between lines. :coffee::coffee::coffee::coffee:

   ```
       ------------------------------
        lines
       ------------------------------
        {9,39}
        {4,39}
        {5,31}
        {4,31}
        {6,39}
        {5,39}
        {9,31}
        {6,31}
        {5,30,31}
        {6,30,31}
        ...
       ------------------------------  
   ```

## Recommended reading
- http://www.postgresql.org/docs/8.4/static/queries-with.html
