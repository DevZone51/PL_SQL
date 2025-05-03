


--Table Partitioning:
Partitioning isolates data, so concurrent transactions target separate partitions, reducing block-level contention.

--Shorten Transactions:
Keeping transactions short minimizes the duration that locks are held.
This reduces the chance for other transactions to attempt to access the same rows, lowering the likelihood of conflicts.

--Concurrency Control
setting MINTRANS and MAXTRANS when defining a table can influence the number of concurrent transactions that can potentially access a data block
without encountering locking conflicts. It defines "interested transaction list" (ITL) within each data block to track which
transactions have locked rows within that block.

ALTER TABLE item_loc_soh_part INITRANS 16 MAXTRANS 255;
