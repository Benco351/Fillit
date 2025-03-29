CREATE TABLE address (
address_id SERIAL PRIMARY KEY,
address_country VARCHAR(255) NOT NULL,
address_city VARCHAR(255) NOT NULL,
address_street VARCHAR(255) NOT NULL,
address_additional_info TEXT
);

CREATE TABLE org_role (
role_id SERIAL PRIMARY KEY,
role_name VARCHAR(255) NOT NULL,
role_description TEXT
);

CREATE TABLE org_admin (
admin_id SERIAL PRIMARY KEY
);

CREATE TABLE org_permission (
permission_id SERIAL PRIMARY KEY,
permission_admin_id INTEGER,
permission_text TEXT,
FOREIGN KEY (permission_admin_id) REFERENCES org_admin(admin_id)
);

CREATE TABLE employee (
employee_id SERIAL PRIMARY KEY,
employee_name VARCHAR(255) NOT NULL,
employee_email VARCHAR(255) NOT NULL,
employee_phone VARCHAR(255) NOT NULL,
employee_password VARCHAR(255) NOT NULL,
employee_role_id INTEGER,
employee_address_id INTEGER,
employee_is_admin INTEGER,
FOREIGN KEY (employee_role_id) REFERENCES org_role(role_id),
FOREIGN KEY (employee_address_id) REFERENCES address(address_id),
FOREIGN KEY (employee_is_admin) REFERENCES org_admin(admin_id)
);

CREATE TABLE organization(
organization_id SERIAL PRIMARY KEY,
organization_name VARCHAR(255) NOT NULL,
organization_password VARCHAR(255) NOT NULL
);

CREATE TABLE org_group(
    org_group_id SERIAL PRIMARY KEY,
    org_group_name VARCHAR(255) NOT NULL
);

CREATE TABLE employee_group (
    e_group_id INTEGER NOT NULL,
    e_employee_id INTEGER NOT NULL,
    PRIMARY KEY (e_group_id, e_employee_id),
    FOREIGN KEY (e_employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (e_group_id) REFERENCES org_group(org_group_id)
);

CREATE TABLE announcment (
    announcment_id SERIAL PRIMARY KEY,
    announcment_title VARCHAR(255) NOT NULL,
    announcment_date DATE
);

CREATE TABLE recipients (
    recipients_group_id INTEGER NOT NULL,
    recipients_announcment_id INTEGER NOT NULL,
    PRIMARY KEY (recipients_group_id, recipients_announcment_id),
    FOREIGN KEY (recipients_group_id) REFERENCES org_group(org_group_id),
    FOREIGN KEY (recipients_announcment_id) REFERENCES announcment(announcment_id)
);

CREATE TABLE department (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(255),
    department_address_id INTEGER,
    department_manager_id INTEGER,
    FOREIGN KEY (department_address_id) REFERENCES address(address_id),
    FOREIGN KEY (department_manager_id) REFERENCES employee(employee_id)

);

CREATE TABLE sub_department (
    sub_department_id SERIAL PRIMARY KEY,
    sub_department_name VARCHAR(255) NOT NULL,
    sub_department_capacity INTEGER,
    main_department_id INTEGER,
    sub_department_manager_id INTEGER,
    FOREIGN KEY (main_department_id) REFERENCES department(department_id),
    FOREIGN KEY (sub_department_manager_id) REFERENCES employee(employee_id)
);

CREATE TABLE avaliable_shift (
    shift_id SERIAL PRIMARY KEY,
    shift_date DATE NOT NULL,
    shift_time_start TIME,
    shift_time_end TIME,
    sub_department_id INTEGER,
    FOREIGN KEY (sub_departmentid) REFERENCES sub_department(sub_department_id)
);

CREATE TABLE assigned_shift (
    assigned_id SERIAL PRIMARY KEY,
    assigned_shift_id INTEGER NOT NULL,
    assigned_employee_id INTEGER NOT NULL,
    FOREIGN KEY (assigned_shift_id) REFERENCES avaliable_shift(shift_id),
    FOREIGN KEY (assigned_employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE requested_shift (
    request_id SERIAL PRIMARY KEY,
    request_shift_id INTEGER NOT NULL,
    request_employee_id INTEGER NOT NULL,
    request_notes TEXT,
    request_status VARCHAR(255),
    FOREIGN KEY (request_shift_id) REFERENCES avaliable_shift(shift_id),
    FOREIGN KEY (request_employee_id) REFERENCES employee(employee_id)
);
