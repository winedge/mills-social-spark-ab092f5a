DROP POLICY IF EXISTS "Anyone can submit a reservation" ON public.reservations;
CREATE POLICY "Anyone can submit a reservation" ON public.reservations FOR INSERT TO anon, authenticated
WITH CHECK (status = 'new' AND length(btrim(name)) BETWEEN 1 AND 200 AND length(email) BETWEEN 3 AND 320 AND email LIKE '%@%' AND length(phone) BETWEEN 3 AND 40 AND party_size BETWEEN 1 AND 500 AND coalesce(length(special_requests),0) <= 2000);

DROP POLICY IF EXISTS "Anyone can submit a space request" ON public.space_reservations;
CREATE POLICY "Anyone can submit a space request" ON public.space_reservations FOR INSERT TO anon, authenticated
WITH CHECK (status = 'new' AND length(btrim(name)) BETWEEN 1 AND 200 AND length(email) BETWEEN 3 AND 320 AND email LIKE '%@%' AND length(phone) BETWEEN 3 AND 40 AND party_size BETWEEN 1 AND 1000 AND length(space) BETWEEN 1 AND 200 AND coalesce(length(message),0) <= 4000);

DROP POLICY IF EXISTS "Anyone can submit an inquiry" ON public.inquiries;
CREATE POLICY "Anyone can submit an inquiry" ON public.inquiries FOR INSERT TO anon, authenticated
WITH CHECK (status = 'new' AND length(btrim(name)) BETWEEN 1 AND 200 AND length(email) BETWEEN 3 AND 320 AND email LIKE '%@%' AND length(phone) <= 40 AND length(kind) BETWEEN 1 AND 50 AND length(subject) <= 300 AND length(message) <= 5000 AND (guests IS NULL OR guests BETWEEN 1 AND 1000));

DROP POLICY IF EXISTS "Anyone can send a message" ON public.contact_messages;
CREATE POLICY "Anyone can send a message" ON public.contact_messages FOR INSERT TO anon, authenticated
WITH CHECK (status = 'new' AND length(btrim(name)) BETWEEN 1 AND 200 AND length(email) BETWEEN 3 AND 320 AND email LIKE '%@%' AND length(phone) <= 40 AND length(subject) <= 300 AND length(message) BETWEEN 1 AND 5000);

DROP POLICY IF EXISTS "Anyone can apply" ON public.job_applications;
CREATE POLICY "Anyone can apply" ON public.job_applications FOR INSERT TO anon, authenticated
WITH CHECK (coalesce(status,'pending') = 'pending' AND length(btrim(full_name)) BETWEEN 1 AND 200 AND length(email) BETWEEN 3 AND 320 AND email LIKE '%@%' AND coalesce(length(phone),0) <= 40 AND coalesce(length(resume_url),0) <= 2000 AND coalesce(length(cover_letter),0) <= 10000);

DROP POLICY IF EXISTS "Anyone can subscribe" ON public.newsletter_subscribers;
CREATE POLICY "Anyone can subscribe" ON public.newsletter_subscribers FOR INSERT TO anon, authenticated
WITH CHECK (length(email) BETWEEN 3 AND 320 AND email LIKE '%@%' AND length(source) BETWEEN 1 AND 50);

DROP POLICY IF EXISTS "Allow authenticated users to manage overrides" ON public.ufc_fighter_overrides;
CREATE POLICY "Admins manage fighter overrides" ON public.ufc_fighter_overrides FOR ALL TO authenticated
USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

DROP POLICY IF EXISTS "Authenticated Upload" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Update" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Delete" ON storage.objects;
CREATE POLICY "site_assets admin insert" ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'site_assets' AND public.has_role(auth.uid(), 'admin'));
CREATE POLICY "site_assets admin update" ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id = 'site_assets' AND public.has_role(auth.uid(), 'admin')) WITH CHECK (bucket_id = 'site_assets' AND public.has_role(auth.uid(), 'admin'));
CREATE POLICY "site_assets admin delete" ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'site_assets' AND public.has_role(auth.uid(), 'admin'));