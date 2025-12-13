INSERT INTO public."user" (client_id, client_secret, scope)
VALUES ('devops', 'devops', ARRAY['push_send'])
ON CONFLICT (client_id) DO NOTHING;
