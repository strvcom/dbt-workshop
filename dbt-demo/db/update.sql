insert into raw.orders values
(100,99,'2018-04-08','placed'),
(101,56,'2018-04-08','placed'),
(102,90,'2018-04-09','placed'),
(103,92,'2018-04-09','placed');

insert into raw.payments values
(114,100,'credit_card',900),
(115,101,'credit_card',1000),
(116,102,'bank_transfer',200),
(117,103,'coupon',300);

update raw.orders set "status" = 'completed' where id = 81;
update raw.orders set "status" = 'completed' where id = 82;
update raw.orders set "status" = 'shipped' where id = 98;
update raw.orders set "status" = 'shipped' where id = 99;