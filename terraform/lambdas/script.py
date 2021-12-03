import os
import shutil


folders = [
    ('currency', 'currencies'),
    ('purchase_order_has_orders', 'purchase_order_has_orders'),
    ('status', 'status'),
    ('client', 'clients'),
    ('order_has_products', 'order_has_products')
]

cwd = os.getcwd()

for f in folders:
    t = os.path.join(cwd, 'get-template')
    print(t)
    new = os.path.join(cwd, f'get-{f[1]}')
    print(new)
    shutil.copytree(t, new)
