
CREATE TABLE tariffs (
    tariff_id NUMBER(2) PRIMARY KEY,
    name VARCHAR2(50) NOT NULL UNIQUE,
    monthly_fee NUMBER(10,2) NOT NULL CHECK (monthly_fee >= 0),
    data_limit NUMBER(10) NOT NULL CHECK (data_limit >= 0),
    minute_limit NUMBER(10) NOT NULL CHECK (minute_limit >= 0),
    sms_limit NUMBER(10) NOT NULL CHECK (sms_limit >= 0)
);

CREATE TABLE customers (
    customer_id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(80) NOT NULL,
    city VARCHAR2(80) NOT NULL,
    signup_date DATE NOT NULL,
    tariff_id NUMBER(2) NOT NULL,
    CONSTRAINT fk_customer_tariff FOREIGN KEY (tariff_id) REFERENCES tariffs (tariff_id)
);

CREATE TABLE monthly_stats (
    id NUMBER(10) PRIMARY KEY,
    customer_id NUMBER(10) NOT NULL,
    data_usage NUMBER(10,2) NOT NULL CHECK (data_usage >= 0),
    minute_usage NUMBER(10) NOT NULL CHECK (minute_usage >= 0),
    sms_usage NUMBER(10) NOT NULL CHECK (sms_usage >= 0),
    payment_status VARCHAR2(10) NOT NULL CHECK (payment_status IN ('PAID','LATE','UNPAID')),
    CONSTRAINT fk_stats_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE INDEX idx_customers_tariff_id ON customers(tariff_id);
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_customers_signup_date ON customers(signup_date);

CREATE INDEX idx_stats_customer_id ON monthly_stats(customer_id);
CREATE INDEX idx_stats_payment_status ON monthly_stats(payment_status);