import '@/lib/errorReporter';
import { enableMapSet } from "immer";
enableMapSet();
import React, { StrictMode, useEffect, Suspense } from 'react'
import { createRoot } from 'react-dom/client'
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import { ErrorBoundary } from '@/components/ErrorBoundary';
import { RouteErrorBoundary } from '@/components/RouteErrorBoundary';
import '@/index.css'
import { Toaster } from 'sonner';
import { Skeleton } from '@/components/ui/skeleton';
// Lazy load the main page for better initial load performance
const HomePage = React.lazy(() => import('@/pages/HomePage').then(module => ({ default: module.HomePage })));
const router = createBrowserRouter([
  {
    path: "/",
    element: <HomePage />,
    errorElement: <RouteErrorBoundary />,
  },
]);
function App() {
  useEffect(() => {
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js')
          .then(registration => console.log('SW registered: ', registration))
          .catch(registrationError => console.log('SW registration failed: ', registrationError));
      });
    }
  }, []);
  return (
    <StrictMode>
      <ErrorBoundary>
        <Suspense fallback={
          <div className="flex h-screen w-screen items-center justify-center bg-background">
            <div className="w-full max-w-md p-8 space-y-4">
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-8 w-3/4" />
              <Skeleton className="h-64 w-full" />
            </div>
          </div>
        }>
          <RouterProvider router={router} />
        </Suspense>
        <Toaster theme="dark" richColors position="top-right" />
      </ErrorBoundary>
    </StrictMode>
  );
}
// Do not touch this code
createRoot(document.getElementById('root')!).render(<App />);
// Export the App component to satisfy the fast refresh lint rule
export default App;