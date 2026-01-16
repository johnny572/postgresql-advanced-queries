/*
Problem: Find Invalid IP Addresses
Source: Interview-level SQL (LeetCode style)
Difficulty: Hard

Table: logs
Columns:
- log_id INT
- ip VARCHAR
- status_code INT

Invalid IPv4 conditions:
1. Any octet > 255
2. Any octet has leading zeros (e.g., 01.02.03.04)
3. IP does not have exactly 4 octets
*/

WITH invalid_ips AS (
    SELECT ip
    FROM logs
    WHERE
        -- Invalid if IPv4 format is incorrect or any octet > 255
        ip !~ '^(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)$'
        
        -- Invalid if any octet contains leading zeros
        OR ip ~ '(^|\\.)(0[0-9]+)(\\.|$)'
)

SELECT
    ip,
    COUNT(*) AS invalid_count
FROM invalid_ips
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC;
