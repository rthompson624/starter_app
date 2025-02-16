import React from 'react';
import { useAuth } from '../contexts/AuthContext';
import Layout from '../components/layout/Layout';

const Profile: React.FC = () => {
  const { user } = useAuth();

  return (
    <Layout>
      <div className="max-w-2xl mx-auto">
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-2xl font-bold mb-6">Profile</h2>
          
          <div className="space-y-4">
            <div>
              <h3 className="text-sm font-medium text-gray-500">Email</h3>
              <p className="mt-1 text-sm text-gray-900">{user?.email}</p>
            </div>
            
            <div>
              <h3 className="text-sm font-medium text-gray-500">Member Since</h3>
              <p className="mt-1 text-sm text-gray-900">
                {new Date().toLocaleDateString()}
              </p>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Profile; 