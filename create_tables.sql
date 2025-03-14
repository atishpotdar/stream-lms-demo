-- Create Announcements table
CREATE TABLE announcements (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    author_name TEXT NOT NULL,
    interest TEXT,
    author_title TEXT,
    author_id UUID NOT NULL,
    content TEXT NOT NULL,
    likes UUID[] DEFAULT '{}',
    author_image TEXT
    
);

-- Create Instructors table
CREATE TABLE instructors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    occupation TEXT,
    bio TEXT,
    url TEXT,
    interest TEXT,
    image TEXT,
    followers UUID[] DEFAULT '{}'
);

-- Create Students table
CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    email TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    interest TEXT,
    following_list UUID[] DEFAULT '{}'
);

-- Add indexes for better query performance
CREATE INDEX idx_announcements_author_id ON announcements(author_id);
CREATE INDEX idx_announcements_interest ON announcements(interest);
CREATE INDEX idx_instructors_interest ON instructors(interest);
CREATE INDEX idx_students_interest ON students(interest);

-- Add policies
CREATE POLICY "Enable delete for users based on user_id"
ON "public".announcements
FOR DELETE
TO authenticated
USING (
  (SELECT auth.uid()) = author_id
);

alter policy "Enable insert for authenticated users only"
on "public"."announcements"
to authenticated
with check (
true
);

CREATE POLICY "Enable read access for all users"
ON "public"."announcements"
FOR SELECT
TO authenticated, anon
USING (
  true
);

alter policy "Enable read access for all users"
on "public"."announcements"
to public
using (
true
);

CREATE POLICY "Enable update for authenticated users"
ON "public"."announcements"
FOR UPDATE
TO authenticated
USING (
  (SELECT auth.uid()) = author_id
);

alter policy "Enable update for authenticated users"
on "public"."announcements"
to authenticated
using (
(auth.role() = 'authenticated'::text)
);

CREATE POLICY "Allow only authenticated users for select"
ON "public"."instructors"
FOR SELECT
TO authenticated
USING (
  true
);

-- Access Policy for the Instructors Table
CREATE POLICY "Allow only authenticated users for insert"
ON "public"."instructors"
FOR INSERT
TO authenticated
WITH CHECK (
  true
);

CREATE POLICY "Allow only authenticated users for update"
ON "public"."instructors"
FOR UPDATE
TO authenticated
USING (
  (auth.role() = 'authenticated'::text)
);

CREATE POLICY "Allow only authenticated users for delete"
ON "public"."instructors"
FOR DELETE
TO authenticated
USING (
  (auth.role() = 'authenticated'::text)
);

CREATE POLICY "Enable read access for all users"
ON "public"."instructors"
FOR SELECT
TO authenticated, anon
USING (
  true
);

alter policy "Enable read access for all users"
on "public"."instructors"
to public
using (
true
);

-- Access Policy for the Students Table

CREATE POLICY "Enable insert for authenticated users only"
ON "public"."students"
FOR INSERT
TO authenticated
WITH CHECK (
  true
);

alter policy "Enable insert for authenticated users only"
on "public"."students"
to authenticated
with check (
true
);

alter policy "Enable update for only authenticated users"
on "public"."students"
to authenticated
using ((auth.role() = 'authenticated'::text))

CREATE POLICY "Read access for only authenticated users"
ON "public"."students"
FOR SELECT
TO authenticated
USING (
  true
);

alter policy "Read access for only authenticated users"
on "public"."students"
to authenticated
using (
true
);

-- Allow authenticated users to upload files
-- have to add anon to work
CREATE POLICY "Allow authenticated uploads"
ON storage.objects
FOR INSERT
TO authenticated, anon
WITH CHECK (true);

-- Allow authenticated users to read files
CREATE POLICY "Allow authenticated downloads"
ON storage.objects
FOR SELECT
TO authenticated
USING (true);

-- Allow authenticated users to update their files
CREATE POLICY "Allow authenticated updates"
ON storage.objects
FOR UPDATE
TO authenticated
USING (true);

-- Allow authenticated users to delete their files
CREATE POLICY "Allow authenticated deletes"
ON storage.objects
FOR DELETE
TO authenticated
USING (true);